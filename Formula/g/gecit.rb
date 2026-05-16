class Gecit < Formula
  desc "DPI bypass tool using fake TLS ClientHello packets"
  homepage "https://github.com/boratanrikulu/gecit"
  url "https://github.com/boratanrikulu/gecit/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "09f5dcdddcab4bab87c5e704f837060f41a8f99ba36959576e9ae16f530eae3b"
  license "GPL-3.0-only"
  head "https://github.com/boratanrikulu/gecit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6465cfffb10d0a0f6c4b31738ee7507ef2fe82bdbc2c0d8fdb90244c8e038aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9cf58d16d09f44c3d0ac06cd6bb3e7813cbb35d33c34c609bcd273c817b0eec7"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gecit"
  end

  test do
    output = shell_output("#{bin}/gecit --help 2>&1")
    assert_match "gecit", output.downcase
  end
end
