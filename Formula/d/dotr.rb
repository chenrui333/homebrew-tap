class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "b1f87c457d1193a26983625febe271265a118e770d8b8b231614d9e341311fe5"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f78f9b9b2e9538ba7e15abd0bcde89e7a85d4bbd107e6c7dc8e1aa0d786ca57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ae0db45d59a9a922c2f3c5241489202ecebb64a264f7858877f947d4928691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2753da252000f5c8ce74731e55d8a32e1dfe66a479f4a12e478194ebd00dcc06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85442b481a6e725602bb1d8870cb4d02b8f5284502134db68ea847c2f384424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db22c4c553292a7d05b6bc6d2aee3e563ceccb8366f0cd0e7a765064e6ced05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotr --version")

    system bin/"dotr", "init"
    assert_path_exists testpath/"config.toml"
    assert_path_exists testpath/".gitignore"
  end
end
