class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "a9b4713ba770ef13d3adcd38aabbd7215f65767314f3d1482b8403ac1431dae2"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f3c3f136d594a0c2a28a3a1f98a36bb62968c1a9fc48ae16edcc55a397ee318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659a1a8a00f5dce1573bc86d335c5a60891fa7132789415d5d9655d1839aecb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0749fee825840e792f75580c334354838b57c667f09075aa65a71113b0f3f8aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea1aad300a959373ec169ca7cf275cecb9a8517e50deba62750bf5341dbe1635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b257496ef86aab1f5e7ec8252b220c0b93dfdaa7d42842e7dd0a3f40e063b161"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
