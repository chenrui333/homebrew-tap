class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "6e1ad348fd83fc35dc9041ad9e49c1165e8f819367171601365816b4c00396f9"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "5b63bee142679977e4e2694eef7021da575b9ab0e745cfa9903194115d5459d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15fda8418ef78af7967e41bdf841591b6e28840c7714c30abdeadd52b58fd001"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b2e691b775a05198ef2b310b75fe80c203c6c4f5767211df4c355375c789ca"
    sha256 cellar: :any,                 arm64_linux:   "c65b2d9acfdabd622a23f4c2fedd112a0b118fd7d919a467d1c33c1582cc1560"
    sha256 cellar: :any,                 x86_64_linux:  "f46d9ec85aadfa4b471ce3a79ba76383a0c7d1bdb632fd1d32c0dcbc03002b20"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotr", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotr --version")

    system bin/"dotr", "init"
    assert_path_exists testpath/"config.toml"
    assert_path_exists testpath/".gitignore"
  end
end
