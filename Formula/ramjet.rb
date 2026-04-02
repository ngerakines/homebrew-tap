# frozen_string_literal: true

require_relative "../lib/atproto"

class Ramjet < Formula
  DID = "did:plc:cbkjy5n7bk3ax2wplmtjofq2"
  COLLECTION = "garden.lexicon.exultant-zebra.distribution"
  RKEY = "3mh4qd2zcln2i"
  RECORD_CID = "bafyreihewtqbe7kvb3lcmytw6hjnp3iypcgg3btnprweldhm7pavklphae"

  def self.distribution
    @distribution ||= Atproto.get_record(DID, COLLECTION, RKEY, cid: RECORD_CID).freeze
  end

  desc "A relay consumer with configurable forward and track collections and record reconciliation"
  homepage "https://tangled.org/ngerakines.me/ramjet"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      artifact = Atproto.find_artifact(Ramjet.distribution, "arm64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(Ramjet.distribution, "amd64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  on_linux do
    on_arm do
      artifact = Atproto.find_artifact(Ramjet.distribution, "arm64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(Ramjet.distribution, "amd64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  def install
    binary = Dir.glob("*").first
    mv binary, "ramjet" if binary && binary != "ramjet"
    chmod 0755, "ramjet"
    bin.install "ramjet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ramjet --version")
  end
end
