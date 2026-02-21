# frozen_string_literal: true

# ATProto helper module for Homebrew formulas.
#
# Provides utilities for working with ATProto blob CIDs:
# - Decoding SHA-256 checksums directly from CIDv1 identifiers
# - Constructing blob download URLs via the XRPC getBlob endpoint
module Atproto
  # RFC 4648 base32 alphabet (case-insensitive, we normalize to uppercase).
  BASE32_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

  # Decode an RFC 4648 base32 string (no padding required) into raw bytes.
  #
  # Ruby's stdlib does not include base32, so this is a minimal inline
  # implementation using a lookup table.
  def self.base32_decode(input)
    table = {}
    BASE32_ALPHABET.each_char.with_index { |c, i| table[c] = i }

    upper = input.upcase
    bits = 0
    buffer = 0
    bytes = []

    upper.each_char do |c|
      raise ArgumentError, "Invalid base32 character: #{c}" unless table.key?(c)

      buffer = (buffer << 5) | table[c]
      bits += 5

      if bits >= 8
        bits -= 8
        bytes << ((buffer >> bits) & 0xFF)
      end
    end

    bytes.pack("C*")
  end

  # Decode a `bafkrei...` CID and return the hex-encoded SHA-256 digest.
  #
  # ATProto blob CIDs with the `bafkrei` prefix are CIDv1 using:
  # - Multibase prefix: `b` (base32lower, RFC 4648)
  # - CID version:      `0x01`
  # - Multicodec:       `0x55` (raw binary)
  # - Multihash func:   `0x12` (sha2-256)
  # - Multihash length: `0x20` (32 bytes)
  #
  # The SHA-256 hash of the blob content is encoded directly in the CID,
  # so we can extract it without downloading the file.
  def self.sha256_from_cid(cid)
    raise ArgumentError, "CID must start with 'b' multibase prefix" unless cid.start_with?("b")

    # Strip the multibase prefix ('b' for base32lower) and decode.
    raw = base32_decode(cid[1..])

    bytes = raw.bytes
    pos = 0

    # CID version — must be 1.
    version = bytes[pos]
    raise ArgumentError, "Expected CIDv1 (0x01), got 0x#{version.to_s(16).rjust(2, '0')}" unless version == 0x01

    pos += 1

    # Multicodec — must be 0x55 (raw).
    codec = bytes[pos]
    raise ArgumentError, "Expected raw codec (0x55), got 0x#{codec.to_s(16).rjust(2, '0')}" unless codec == 0x55

    pos += 1

    # Multihash function — must be 0x12 (sha2-256).
    hash_func = bytes[pos]
    raise ArgumentError, "Expected sha2-256 (0x12), got 0x#{hash_func.to_s(16).rjust(2, '0')}" unless hash_func == 0x12

    pos += 1

    # Multihash digest length — must be 0x20 (32 bytes).
    hash_len = bytes[pos]
    raise ArgumentError, "Expected 32-byte digest (0x20), got 0x#{hash_len.to_s(16).rjust(2, '0')}" unless hash_len == 0x20

    pos += 1

    # Extract the 32-byte SHA-256 digest.
    digest = bytes[pos, 32]
    raise ArgumentError, "CID too short: expected 32 digest bytes, got #{digest.length}" unless digest.length == 32

    digest.pack("C*").unpack1("H*")
  end

  # Construct a getBlob XRPC URL for downloading a blob from an ATProto PDS.
  #
  # @param did [String] the repo DID (e.g. "did:plc:...")
  # @param cid [String] the blob CID
  # @param pds [String] the PDS base URL (default: pds.cauda.cloud)
  # @return [String] the full getBlob URL
  def self.blob_url(did, cid, pds: "https://pds.cauda.cloud")
    "#{pds}/xrpc/com.atproto.sync.getBlob?did=#{did}&cid=#{cid}"
  end
end
