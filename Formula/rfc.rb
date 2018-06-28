class Rfc < Formula
  desc "Bash tool to read RFCs from the command-line"
  homepage "https://github.com/bfontaine/rfc#readme"
  url "https://github.com/bfontaine/rfc/archive/v0.2.5.tar.gz"
  sha256 "6a1355bf40485a5dcbb4a673b8d23a22cbae132c0e0a6cf82f8c3d3ecf055ff1"

  def install
    bin.install "rfc"
  end

  test do
    ENV["PAGER"] = "cat"
    assert_match "Message Data Types", shell_output("#{bin}/rfc 42")
  end
end
