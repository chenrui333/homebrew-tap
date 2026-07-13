class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "1f01e549a6d54df7aaf1849d835b9b9bd94f7d38ebfe8d59d6b14891bbdf8573"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ab7d97ac426d322da00c4968431c367d146650ca15cea221b7ed16c18e18549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ea1bf696077338e968067bf9e70e1ab8bdd1e9ae4414ae993aeefe651b5e5e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "329c15a17ee7932676881dcbda19f55635a9c3e21d933f41e8e75ae9cb423c8f"
    sha256 cellar: :any,                 arm64_linux:   "5dc3e125197bf9e6650339e42e000307b7d245906f841398cf6f3d30ab689b28"
    sha256 cellar: :any,                 x86_64_linux:  "c6ab9195981d37f99aa15ff29acb65f197c025834405e05f6adf1d5bf9d1fc14"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
