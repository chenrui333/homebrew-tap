class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.41.5.tar.gz"
  sha256 "cb4c76c8e64f347722913c7c7e3b87ca15647160871a4874b80965ac2e8103dd"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52ec05227a85c828d1dc8cd57d0c746fd7cc27c6ab79764b5e6b5cdb95c36006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60db58f3174648d00a702b80a2283901acf30c927d2f4694baee5d2cee6d330a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d69145cd57b940b1692f1e8c025183c3d3bc52899661047d62ffa484e8bd94"
    sha256 cellar: :any,                 arm64_linux:   "4634fb01c3a78dfd122782d35411f9bc2bea9ec4f2d0cd740a311087836e8eaa"
    sha256 cellar: :any,                 x86_64_linux:  "8714d5f4c3aff51e01e33ea9ea5ef8b537c4fd65d4221b0a41881aa3d1fe331e"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
