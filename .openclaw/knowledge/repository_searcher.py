"""
Repository Searcher.

Interface for searching the repository knowledge base.
"""

from typing import List, Dict, Optional
from .repository_indexer import RepositoryIndexer, RepositoryConfig
import logging

logger = logging.getLogger(__name__)


class RepositorySearcher:
    """Search interface for repository knowledge."""
    
    def __init__(self, index_path: str, repo_path: str):
        self.config = RepositoryConfig(repo_path=repo_path)
        self.indexer = RepositoryIndexer(self.config)
        self.index_path = index_path
        self._load_index()
        
    def _load_index(self):
        """Load the vector index."""
        self.indexer.load_index(self.index_path)
        
    def search(self, query: str, limit: int = 5) -> List[Dict]:
        """
        Search the codebase.
        
        Args:
            query: Search query
            limit: Maximum number of results
            
        Returns:
            List of search results with content and metadata
        """
        return self.indexer.query(query, k=limit)
        
    def refresh_index(self):
        """Re-index the repository."""
        logger.info("Refreshing repository index...")
        self.indexer.create_index()
        self.indexer.save_index(self.index_path)
        logger.info("Index refreshed")
