# frozen_string_literal: true

require_relative "../lib/atproto"

class Atpcid < Formula
  DID = "did:plc:cbkjy5n7bk3ax2wplmtjofq2"
  COLLECTION = "garden.lexicon.exultant-zebra.distribution"
  RKEY = "3mijiwunapa2c"
  RECORD_CID = "bafyreiebx5wqqa7ffsbut4gzei7d6ox5km6ct2igse4ynjpdwdxbwo4qx4"

  DISTRIBUTION = Atproto.get_record(DID, COLLECTION, RKEY, cid: RECORD_CID).freeze

  desc "CID resolver for the AT Protocol"
  homepage "https://tangled.org/ngerakines.me/atproto-crates"
  version "0.14.5"
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
    mv binary, "atpcid" if binary && binary != "atpcid"
    chmod 0755, "atpcid"
    bin.install "atpcid"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atpcid --version")
  end
end
