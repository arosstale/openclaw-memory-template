"""
Knowledge Processor.

Orchestrates the knowledge system components.
"""

import os
from pathlib import Path
from typing import Optional
from .repository_indexer import RepositoryIndexer, RepositoryConfig
from .repository_searcher import RepositorySearcher
from ..core.registry import Registry

class KnowledgeSystem:
    """
    Main entry point for the Knowledge System.
    Manages indexing and searching of the codebase.
    """
    
    def __init__(self, repo_path: str = ".", index_path: str = ".openclaw/knowledge_index"):
        self.repo_path = repo_path
        self.index_path = index_path
        self.searcher: Optional[RepositorySearcher] = None
        
        # Register self
        Registry.register("knowledge_system", self)
        
    def initialize(self):
        """Initialize the knowledge system."""
        # Check if index exists
        if not os.path.exists(self.index_path):
            print(f"Creating initial index for {self.repo_path}...")
            config = RepositoryConfig(repo_path=self.repo_path)
            indexer = RepositoryIndexer(config)
            indexer.create_index()
            indexer.save_index(self.index_path)
            
        self.searcher = RepositorySearcher(self.index_path, self.repo_path)
        print("Knowledge system initialized")
        
    def search(self, query: str, k: int = 5):
        """Search the knowledge base."""
        if not self.searcher:
            self.initialize()
            
        return self.searcher.search(query, limit=k)

    def reindex(self):
        """Force reindexing."""
        if self.searcher:
            self.searcher.refresh_index()
        else:
            self.initialize()
