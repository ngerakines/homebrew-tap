# frozen_string_literal: true

require_relative "../lib/atproto"

class Atptid < Formula
  DID = "did:plc:cbkjy5n7bk3ax2wplmtjofq2"
  COLLECTION = "garden.lexicon.exultant-zebra.distribution"
  RKEY = "3mijixeitui2c"
  RECORD_CID = "bafyreig4ngf6kov2mo2dp7gb63gesvps4efysoe4vlf7fmjak5w56n3t5m"

  def self.distribution
    @distribution ||= Atproto.get_record(DID, COLLECTION, RKEY, cid: RECORD_CID).freeze
  end

  desc "ATProtocol TID generator and parser"
  homepage "https://tangled.org/ngerakines.me/atproto-crates"
  version "0.14.5"
  license "MIT"

  on_macos do
    on_arm do
      artifact = Atproto.find_artifact(Atptid.distribution, "arm64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(Atptid.distribution, "amd64", "darwin")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  on_linux do
    on_arm do
      artifact = Atproto.find_artifact(Atptid.distribution, "arm64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
    on_intel do
      artifact = Atproto.find_artifact(Atptid.distribution, "amd64", "linux")
      cid = Atproto.blob_cid_from_artifact(artifact)
      url Atproto.blob_url(DID, cid)
      sha256 Atproto.sha256_from_cid(cid)
    end
  end

  def install
    binary = Dir.glob("*").first
    mv binary, "atptid" if binary && binary != "atptid"
    chmod 0755, "atptid"
    bin.install "atptid"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atptid --version")
  end
end
