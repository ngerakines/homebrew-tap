# homebrew-tap

Homebrew tap for [atpcid](https://github.com/ngerakines/atproto-rs), a CID resolver for the AT Protocol.

## Install

```sh
brew install ngerakines/tap/atpcid
```

Or add the tap first:

```sh
brew tap ngerakines/tap
brew install atpcid
```

## How it works

Binaries are hosted on ATProto PDS blob storage at `pds.cauda.cloud`, not GitHub Releases. Each binary is uploaded as a blob and referenced by a content-addressed CID.

The formula resolves binaries through a two-step process:

1. **Distribution record** — The formula fetches a `garden.lexicon.exultant-zebra.distribution` record from the PDS via `com.atproto.repo.getRecord`. This record contains the version string and a list of artifacts, each tagged by platform (e.g. `arm64`, `darwin`). The request is pinned to a specific record CID for determinism.

2. **Artifact resolution** — The formula matches the current platform's tags against the distribution's artifacts to find the correct blob CID, then derives the download URL and SHA-256 checksum from it.

The `lib/atproto.rb` helper module decodes the SHA-256 checksum directly from the blob CID — ATProto blob CIDs with the `bafkrei` prefix encode a SHA-256 hash using CIDv1 with raw codec and sha2-256 multihash. This means only the distribution record reference needs to be tracked; download URLs and checksums for all platforms are derived from it.

## Updating the formula

When a new version is released:

1. Publish an updated `garden.lexicon.exultant-zebra.distribution` record to the PDS with the new version and artifact blob CIDs.
2. Update the `RECORD_CID` constant in `Formula/atpcid.rb` to the new record's CID.
3. Update the `RKEY` constant if a new record key is used.
4. The version, download URLs, and SHA-256 checksums are all derived automatically from the distribution record.
