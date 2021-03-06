# Copyright Mirage authors & contributors <https://github.com/mirukana/mirage>
# SPDX-License-Identifier: LGPL-3.0-or-later

from dataclasses import dataclass, field
from pathlib import Path
from typing import TYPE_CHECKING, Any, Dict, Optional, Sequence, Type, Union

import pyotherside

from .utils import serialize_value_for_qml

if TYPE_CHECKING:
    from .models import SyncId
    from .user_files import UserFile


@dataclass
class PyOtherSideEvent:
    """Event that will be sent on instanciation to QML by PyOtherSide."""

    def __post_init__(self) -> None:
        # XXX: CPython 3.6 or any Python implemention >= 3.7 is required for
        # correct __dataclass_fields__ dict order.
        args = [
            serialize_value_for_qml(getattr(self, field))
            for field in self.__dataclass_fields__  # type: ignore
            if field != "callbacks"
        ]
        pyotherside.send(type(self).__name__, *args)


@dataclass
class NotificationRequested(PyOtherSideEvent):
    """Request a notification bubble, sound or window urgency hint.

    Urgency hints usually flash or highlight the program's icon in a taskbar,
    dock or panel.
    """

    id:           str  = field()
    critical:     bool = False
    bubble:       bool = False
    sound:        bool = False
    urgency_hint: bool = False

    # Bubble parameters
    title: str              = ""
    body:  str              = ""
    image: Union[Path, str] = ""


@dataclass
class CoroutineDone(PyOtherSideEvent):
    """Indicate that an asyncio coroutine finished."""

    uuid:      str                 = field()
    result:    Any                 = None
    exception: Optional[Exception] = None
    traceback: Optional[str]       = None


@dataclass
class LoopException(PyOtherSideEvent):
    """Indicate an uncaught exception occurance in the asyncio loop."""

    message:   str                 = field()
    exception: Optional[Exception] = field()
    traceback: Optional[str]       = None


@dataclass
class Pre070SettingsDetected(PyOtherSideEvent):
    """Warn that a pre-0.7.0 settings.json file exists."""
    path: Path = field()


@dataclass
class UserFileChanged(PyOtherSideEvent):
    """Indicate that a config or data file changed on disk."""

    type:     Type["UserFile"] = field()
    new_data: Any              = field()


@dataclass
class ModelEvent(PyOtherSideEvent):
    """Base class for model change events."""

    sync_id: "SyncId" = field()


@dataclass
class ModelItemSet(ModelEvent):
    """Indicate `ModelItem` insert or field changes in a `Backend` `Model`."""

    index_then: Optional[int]  = field()
    index_now:  int            = field()
    fields:     Dict[str, Any] = field()


@dataclass
class ModelItemDeleted(ModelEvent):
    """Indicate the removal of a `ModelItem` from a `Backend` `Model`."""

    index: int           = field()
    count: int           = 1
    ids:   Sequence[Any] = ()


@dataclass
class ModelCleared(ModelEvent):
    """Indicate that a `Backend` `Model` was cleared."""


@dataclass
class DevicesUpdated(PyOtherSideEvent):
    """Indicate changes in devices for us or users we share a room with."""

    our_user_id: str = field()


@dataclass
class InvalidAccessToken(PyOtherSideEvent):
    """Indicate one of our account's access token is invalid or revoked."""

    user_id: str = field()
