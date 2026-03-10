# frozen_string_literal: true

require_relative "../lib/atproto"

class Atpxrpc < Formula
  DID = "did:plc:cbkjy5n7bk3ax2wplmtjofq2"
  COLLECTION = "garden.lexicon.exultant-zebra.distribution"
  RKEY = "3mgpke635qf2i"
  RECORD_CID = "bafyreifiybtpzvfyudqbybwacgsyvd5j236acxpvy4egeazm3s4g56d3wy"

  DISTRIBUTION = Atproto.get_record(DID, COLLECTION, RKEY, cid: RECORD_CID).freeze

  desc "XRPC client for the AT Protocol"
  homepage "https://tangled.org/ngerakines.me/atproto-crates"
  version "0.14.2"
  license "MIT"

  on_macos do
    on_arm do
      artifact = Atproto.find_artifact(DISTRIBUTION, "arm64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(DISTRIBUTION, "amd64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  on_linux do
    on_arm do
      artifact = Atproto.find_artifact(DISTRIBUTION, "arm64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(DISTRIBUTION, "amd64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  def install
    binary = Dir.glob("*").first
    mv binary, "atpxrpc" if binary && binary != "atpxrpc"
    chmod 0755, "atpxrpc"
    bin.install "atpxrpc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atpxrpc --version")
  end
end
