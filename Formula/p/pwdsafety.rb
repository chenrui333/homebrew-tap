class Pwdsafety < Formula
  desc "CLI checking password safety"
  homepage "https://github.com/edoardottt/pwdsafety"
  url "https://github.com/edoardottt/pwdsafety/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "6676f7ccc1ad32e8c68b889426b563d69080a69c1f9212b32d79fccc2e70b79f"
  license "GPL-3.0-only"
  head "https://github.com/edoardottt/pwdsafety.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef274b4818520a472214925ce3f3d438672035051eb75a6318224b3711493931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef274b4818520a472214925ce3f3d438672035051eb75a6318224b3711493931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "221ea1ff6f7a5b99d04360c7fb0ee2042082fb3d73edbe0f1fea1089f0737de6"
    sha256 cellar: :any,                 x86_64_linux:  "434e62586ecedf4d7ce33eb4b59e9d7981defb2c872980316d6034b171f645ee"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pwdsafety"
  end

  test do
    output = pipe_output("#{bin}/pwdsafety 2>&1", "123\n", 1)
    assert_match "Hey....Do you know what password cracking is?", output
  end
end
