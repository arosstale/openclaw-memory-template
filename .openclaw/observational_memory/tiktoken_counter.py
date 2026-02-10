"""
Token counter using Tiktoken for accurate token counting.

This replaces the simple word-based estimation with accurate token counting
supported by OpenAI models.
"""

import os
from typing import List


class TokenCounter:
    """Token counter using Tiktoken for accurate counts."""

    def __init__(self, encoding_name: str = "cl100k_base"):
        """
        Initialize token counter.

        Args:
            encoding_name: Tiktoken encoding name (default: cl100k_base for GPT-4/3.5)
        """
        self.encoding_name = encoding_name

        # Try to import tiktoken
        try:
            import tiktoken
            self.encoding = tiktoken.get_encoding(encoding_name)
            self.use_tiktoken = True
        except ImportError:
            # Fallback to word-based estimation
            self.encoding = None
            self.use_tiktoken = False

    def count_tokens(self, text: str) -> int:
        """
        Count tokens in text.

        Args:
            text: Input text

        Returns:
            Token count
        """
        if self.use_tiktoken:
            return len(self.encoding.encode(text))
        else:
            # Fallback: ~4 tokens per word
            return len(text.split()) * 4

    def count_observations(self, observations: List) -> int:
        """
        Count tokens for a list of observations.

        Args:
            observations: List of Observation objects

        Returns:
            Total token count
        """
        if not observations:
            return 0

        total_tokens = 0
        for obs in observations:
            # Count content + metadata
            content_tokens = self.count_tokens(obs.content)
            # Add small overhead for metadata
            total_tokens += content_tokens + 10

        return total_tokens

    def count_messages(self, messages: List[dict]) -> int:
        """
        Count tokens for a list of messages.

        Args:
            messages: List of message dicts with 'content' key

        Returns:
            Total token count
        """
        if not messages:
            return 0

        total_tokens = 0
        for msg in messages:
            content = msg.get("content", "")
            # Add small overhead for message structure
            total_tokens += self.count_tokens(content) + 5

        return total_tokens


def get_token_counter(encoding: str = "cl100k_base") -> TokenCounter:
    """
    Get token counter instance.

    Args:
        encoding: Tiktoken encoding name

    Returns:
        TokenCounter instance
    """
    return TokenCounter(encoding)


__all__ = ["TokenCounter", "get_token_counter"]
