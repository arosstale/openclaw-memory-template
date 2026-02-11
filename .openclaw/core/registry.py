"""
Component Registry.

A centralized registry for managing components, tools, and configurations.
"""

from typing import Dict, Any, Optional, Type, List
import logging
from dataclasses import dataclass, field

logger = logging.getLogger(__name__)


@dataclass
class ComponentInfo:
    """Information about a registered component."""
    name: str
    instance: Any
    metadata: Dict[str, Any] = field(default_factory=dict)


class Registry:
    """
    Central registry for system components.
    
    Allows components to register themselves and be discovered by others.
    Useful for managing singletons, plugins, and shared resources.
    """
    
    _instance = None
    _components: Dict[str, ComponentInfo] = {}
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Registry, cls).__new__(cls)
            cls._instance._components = {}
        return cls._instance
    
    @classmethod
    def register(cls, name: str, instance: Any, **metadata):
        """Register a component."""
        if name in cls._components:
            logger.warning(f"Overwriting component '{name}' in registry")
            
        cls._components[name] = ComponentInfo(name=name, instance=instance, metadata=metadata)
        logger.debug(f"Registered component: {name}")
        
    @classmethod
    def get(cls, name: str) -> Optional[Any]:
        """Get a component by name."""
        info = cls._components.get(name)
        return info.instance if info else None
        
    @classmethod
    def list_components(cls) -> List[str]:
        """List all registered component names."""
        return list(cls._components.keys())
        
    @classmethod
    def unregister(cls, name: str):
        """Unregister a component."""
        if name in cls._components:
            del cls._components[name]
            logger.debug(f"Unregistered component: {name}")

    @classmethod
    def get_by_metadata(cls, key: str, value: Any) -> List[Any]:
        """Get components matching metadata."""
        results = []
        for info in cls._components.values():
            if info.metadata.get(key) == value:
                results.append(info.instance)
        return results
