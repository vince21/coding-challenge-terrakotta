"""
CANDIDATE TODO: Fix this module!

The current implementation is broken and produces inconsistent results.
You need to:
1. Define proper Pydantic models for structured output
2. Use OpenAI's structured output feature (response_format)
3. Add proper error handling
"""

from typing import Dict, Any
from pydantic import BaseModel

# TODO: Define proper Pydantic models for structured output
# These models will be used with OpenAI's response_format parameter
# Think about what fields you need for person and address normalization

class PersonData(BaseModel):
    """TODO: Define the person data model"""
    pass

class AddressData(BaseModel):
    """TODO: Define the address data model"""
    pass

class NormalizedData(BaseModel):
    """TODO: Complete the normalized data model for structured output"""
    pass


def normalize_with_ai(name: str, address: str) -> Dict[str, Any]:
    """
    TODO: Implement this function to use OpenAI's structured output to normalize and return the name and address.
    """

    return {
        "name": "NOT IMPLEMENTED",
        "address": "NOT IMPLEMENTED"
    }