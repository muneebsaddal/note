#!/bin/sh
cd "$(dirname "$0")" && swiftc Shared/Note.swift Check/main.swift -o /tmp/note-check && /tmp/note-check
