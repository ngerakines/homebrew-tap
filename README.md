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

The `lib/atproto.rb` helper module decodes the SHA-256 checksum directly from the blob CID — ATProto blob CIDs with the `bafkrei` prefix encode a SHA-256 hash using CIDv1 with raw codec and sha2-256 multihash. This means only the CID needs to be tracked per architecture; the download URL and checksum are both derived from it.

Release metadata is stored as an ATProto record:

```
https://pds.cauda.cloud/xrpc/com.atproto.repo.getRecord?repo=did:plc:cbkjy5n7bk3ax2wplmtjofq2&collection=dev.ngerakines.app&rkey=3mff5brrbbl2i
```

## Updating the formula

When a new version is released:

1. Update the `version` string in `Formula/atpcid.rb`.
2. Replace the CID string in the relevant architecture block with the new blob CID.
3. The SHA-256 checksum and download URL are derived automatically from the CID.
