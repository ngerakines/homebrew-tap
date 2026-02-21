# frozen_string_literal: true

require_relative "../lib/atproto"

class Atpcid < Formula
  DID = "did:plc:cbkjy5n7bk3ax2wplmtjofq2"

  desc "CID resolver for the AT Protocol"
  homepage "https://github.com/ngerakines/atproto-rs"
  version "0.14.0"
  license "MIT"

  on_macos do
    on_arm do
      cid = "bafkreidnh3ed7slspijcy5yipzlza25br5jkoctehgxfbtvphoksevdwyq"
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
