class Ingero < Formula
  desc "GPU causal observability agent using eBPF"
  homepage "https://github.com/ingero-io/ingero"
  url "https://github.com/ingero-io/ingero/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "297b2b1fc6f0701d48bde30b417cb25f9d29673ef2ec5ec4629d1da4990b2f09"
  license "Apache-2.0"
  head "https://github.com/ingero-io/ingero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "887eac3526c7ac621d108af97db72a958e28d6685842945fedfa582eccda4595"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2365c45dec530913b91807a3a33784490c6451208b2fbd047c75d684ec9b5321"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ingero"
  end

  test do
    assert_match "ingero", shell_output("#{bin}/ingero --help 2>&1").downcase
  end
end
