from __future__ import annotations

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pytest import CaptureFixture


def test_janus(capfd: CaptureFixture[str]) -> None:
    """Verify the readme example."""
    from janus_swi import query_once

    result = query_once("writeln('Hello world!')")
    cap = capfd.readouterr()
    assert (result, "".join(cap).strip()) == ({"truth": True}, "Hello world!")
