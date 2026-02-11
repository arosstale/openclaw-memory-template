"""
Repository Indexer.

Indexes codebase files for semantic search.
"""

import os
import glob
from pathlib import Path
from typing import List, Dict, Optional, Any
import logging
from dataclasses import dataclass

logger = logging.getLogger(__name__)

# Mock types for demonstration if dependencies are missing
try:
    from langchain.text_splitter import RecursiveCharacterTextSplitter
    from langchain.docstore.document import Document
    from langchain_community.vectorstores import FAISS
    from langchain_openai import OpenAIEmbeddings
except ImportError:
    logger.warning("LangChain not installed. RepositoryIndexer will run in mock mode.")
    RecursiveCharacterTextSplitter = None
    Document = None
    FAISS = None
    OpenAIEmbeddings = None


@dataclass
class RepositoryConfig:
    """Configuration for repository indexing."""
    repo_path: str
    include_patterns: List[str] = None
    exclude_patterns: List[str] = None
    chunk_size: int = 1000
    chunk_overlap: int = 200
    embedding_model: str = "text-embedding-3-small"
    
    def __post_init__(self):
        if self.include_patterns is None:
            self.include_patterns = ["**/*.py", "**/*.md", "**/*.json", "**/*.yml"]
        if self.exclude_patterns is None:
            self.exclude_patterns = ["**/__pycache__/**", "**/.git/**", "**/node_modules/**"]


class RepositoryIndexer:
    """Indexes a repository for semantic search."""
    
    def __init__(self, config: RepositoryConfig):
        self.config = config
        self.vectorstore = None
        
    def load_files(self) -> List[Dict[str, str]]:
        """Load files from the repository."""
        documents = []
        repo_path = Path(self.config.repo_path)
        
        if not repo_path.exists():
            logger.error(f"Repository path does not exist: {repo_path}")
            return []
            
        # Simplistic glob handling
        for pattern in self.config.include_patterns:
            for file_path in repo_path.glob(pattern):
                # Skip excluded
                if any(file_path.match(ex) for ex in self.config.exclude_patterns):
                    continue
                    
                if file_path.is_file():
                    try:
                        with open(file_path, "r", encoding="utf-8") as f:
                            content = f.read()
                            documents.append({
                                "path": str(file_path.relative_to(repo_path)),
                                "content": content
                            })
                    except Exception as e:
                        logger.warning(f"Failed to read {file_path}: {e}")
                        
        logger.info(f"Loaded {len(documents)} files from {repo_path}")
        return documents

    def create_index(self):
        """Create vector index from loaded files."""
        if not RecursiveCharacterTextSplitter:
            logger.warning("Cannot create index: dependencies missing.")
            return
            
        raw_files = self.load_files()
        if not raw_files:
            return

        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=self.config.chunk_size,
            chunk_overlap=self.config.chunk_overlap
        )
        
        docs = []
        for file in raw_files:
            chunks = text_splitter.create_documents(
                [file["content"]], 
                metadatas=[{"source": file["path"]}]
            )
            docs.extend(chunks)
            
        logger.info(f"Created {len(docs)} chunks for indexing")
        
        embeddings = OpenAIEmbeddings(model=self.config.embedding_model)
        self.vectorstore = FAISS.from_documents(docs, embeddings)
        logger.info("Vector store created successfully")
        
    def save_index(self, path: str):
        """Save index to disk."""
        if self.vectorstore:
            self.vectorstore.save_local(path)
            logger.info(f"Index saved to {path}")
            
    def load_index(self, path: str):
        """Load index from disk."""
        if not FAISS:
            return
            
        embeddings = OpenAIEmbeddings(model=self.config.embedding_model)
        if os.path.exists(path):
            self.vectorstore = FAISS.load_local(path, embeddings, allow_dangerous_deserialization=True)
            logger.info(f"Index loaded from {path}")
        else:
            logger.warning(f"Index path not found: {path}")

    def query(self, query: str, k: int = 4) -> List[Dict]:
        """Query the index."""
        if not self.vectorstore:
            logger.warning("Index not initialized")
            return []
            
        results = self.vectorstore.similarity_search_with_score(query, k=k)
        return [
            {
                "content": doc.page_content,
                "metadata": doc.metadata,
                "score": score
            }
            for doc, score in results
        ]
