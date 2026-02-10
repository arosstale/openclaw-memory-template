"""
LLM Client for OpenClaw Observational Memory.

Supports Anthropic, OpenAI, and Google for LLM-based
observation extraction and reflection.
"""

import os
from typing import Optional, Dict, List
from abc import ABC, abstractmethod


class LLMClient(ABC):
    """Abstract base class for LLM clients."""

    @abstractmethod
    def generate(
        self,
        prompt: str,
        system: Optional[str] = None,
        temperature: float = 0.3,
        max_tokens: int = 1000
    ) -> str:
        """Generate text from LLM."""
        pass


class AnthropicClient(LLMClient):
    """Anthropic Claude client."""

    def __init__(self, api_key: Optional[str] = None):
        """Initialize Anthropic client."""
        self.api_key = api_key or os.environ.get("ANTHROPIC_API_KEY")
        if not self.api_key:
            raise ValueError("ANTHROPIC_API_KEY not set")

        try:
            import anthropic
            self.client = anthropic.Anthropic(api_key=self.api_key)
        except ImportError:
            raise ImportError("Install anthropic: pip install anthropic")

    def generate(
        self,
        prompt: str,
        system: Optional[str] = None,
        temperature: float = 0.3,
        max_tokens: int = 1000
    ) -> str:
        """Generate text using Anthropic Claude."""
        kwargs = {
            "model": "claude-sonnet-4-20250214",
            "max_tokens": max_tokens,
            "temperature": temperature,
            "messages": [{"role": "user", "content": prompt}],
        }
        if system:
            kwargs["system"] = system

        response = self.client.messages.create(**kwargs)
        return response.content[0].text


class OpenAIClient(LLMClient):
    """OpenAI GPT client."""

    def __init__(self, api_key: Optional[str] = None):
        """Initialize OpenAI client."""
        self.api_key = api_key or os.environ.get("OPENAI_API_KEY")
        if not self.api_key:
            raise ValueError("OPENAI_API_KEY not set")

        try:
            import openai
            self.client = openai.OpenAI(api_key=self.api_key)
        except ImportError:
            raise ImportError("Install openai: pip install openai")

    def generate(
        self,
        prompt: str,
        system: Optional[str] = None,
        temperature: float = 0.3,
        max_tokens: int = 1000
    ) -> str:
        """Generate text using OpenAI GPT."""
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})

        response = self.client.chat.completions.create(
            model="gpt-4o",
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens,
        )
        return response.choices[0].message.content


class GoogleClient(LLMClient):
    """Google Gemini client."""

    def __init__(self, api_key: Optional[str] = None):
        """Initialize Google client."""
        self.api_key = api_key or os.environ.get("GOOGLE_API_KEY")
        if not self.api_key:
            raise ValueError("GOOGLE_API_KEY not set")

        try:
            import google.generativeai as genai
            genai.configure(api_key=self.api_key)
            self.client = genai.GenerativeModel("gemini-2.5-pro")
        except ImportError:
            raise ImportError("Install google-generativeai: pip install google-generativeai")

    def generate(
        self,
        prompt: str,
        system: Optional[str] = None,
        temperature: float = 0.3,
        max_tokens: int = 1000
    ) -> str:
        """Generate text using Google Gemini."""
        full_prompt = prompt
        if system:
            full_prompt = f"{system}\n\n{prompt}"

        response = self.client.generate_content(
            full_prompt,
            generation_config={
                "temperature": temperature,
                "max_output_tokens": max_tokens,
            }
        )
        return response.text


def get_llm_client(provider: str = "anthropic", api_key: Optional[str] = None) -> LLMClient:
    """
    Get LLM client by provider.

    Args:
        provider: "anthropic", "openai", or "google"
        api_key: Optional API key (falls back to env vars)

    Returns:
        LLMClient instance

    Raises:
        ValueError: If provider is unknown
    """
    providers = {
        "anthropic": AnthropicClient,
        "openai": OpenAIClient,
        "google": GoogleClient,
    }

    provider_lower = provider.lower()
    if provider_lower not in providers:
        raise ValueError(f"Unknown provider: {provider}. Use: {', '.join(providers.keys())}")

    return providers[provider_lower](api_key)


__all__ = [
    "LLMClient",
    "AnthropicClient",
    "OpenAIClient",
    "GoogleClient",
    "get_llm_client",
]
