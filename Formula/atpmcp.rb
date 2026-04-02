# frozen_string_literal: true

require_relative "../lib/atproto"

class Atpmcp < Formula
  DID = "did:plc:cbkjy5n7bk3ax2wplmtjofq2"
  COLLECTION = "garden.lexicon.exultant-zebra.distribution"
  RKEY = "3mijix6foqq2c"
  RECORD_CID = "bafyreiclgfg2vcuvz7hxgsttw7se4rxdvkpblfudcov5pwggjylsv244u4"

  def self.distribution
    @distribution ||= Atproto.get_record(DID, COLLECTION, RKEY, cid: RECORD_CID).freeze
  end

  desc "MCP server for the AT Protocol"
  homepage "https://tangled.org/ngerakines.me/atproto-crates"
  version "0.14.5"
  license "MIT"

  on_macos do
    on_arm do
      artifact = Atproto.find_artifact(Atpmcp.distribution, "arm64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(Atpmcp.distribution, "amd64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  on_linux do
    on_arm do
      artifact = Atproto.find_artifact(Atpmcp.distribution, "arm64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(Atpmcp.distribution, "amd64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  def install
    binary = Dir.glob("*").first
    mv binary, "atpmcp" if binary && binary != "atpmcp"
    chmod 0755, "atpmcp"
    bin.install "atpmcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atpmcp --version")
  end
end
