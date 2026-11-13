class Allinssl < Formula
  desc "All-in-one SSL certificate lifecycle management tool"
  homepage "https://allinssl.com/"
  url "https://github.com/allinssl/allinssl/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "dbb82e1f2371a0a1c2538cf61f938a26c3400cd5905c2014c1a26dcb5d3f75fe"
  license "GPL-3.0-only"
  head "https://github.com/allinssl/allinssl.git", branch: "1.1.1"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d17d094e0b54ad6cbf2c7a1132c4351398343c6d375fc46ebe1a7bdd54596cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d17d094e0b54ad6cbf2c7a1132c4351398343c6d375fc46ebe1a7bdd54596cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf9dc3133d496a2dd01f9a658f287f796bd018136d7af2610574c27c0f899b9b"
    sha256 cellar: :any,                 x86_64_linux:  "59a978595a5dffef8c6e1ab9d2e662fcb60042d97c6fb95e30ab928ad36a7952"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd"
  end

  test do
    assert_match "Restarting ALLinSSL...", shell_output("#{bin}/allinssl 3")
    assert_match "无效的命令", shell_output("#{bin}/allinssl 16")
  end
end
