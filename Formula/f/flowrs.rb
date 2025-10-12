class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a082a5e63842e3435c410440ad09a411726f2488ad9cc93ab6e85cd53371ccd"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0e95e06bc4e98fb04714522641d24fce241ca88afda396779ce176b253c133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baadf1b6dd47282082bff13d75c5550c49b43973887eec77f11095055bbbca1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac04c6f35efdf6440411d227a113336748a2aaf19359ddeed901954dba8ff12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb982bc957267f89833cecdf6cbc025937ea971c0d31a5fb7ef28108031d481f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c216660cc11f116a6c345e176b4553165e3bf363e5976500ef1240ab4bc765"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
