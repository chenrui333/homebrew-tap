class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "6e1ad348fd83fc35dc9041ad9e49c1165e8f819367171601365816b4c00396f9"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "d8921d6896005c7f03330934663230a105fa47eb615d0d157de89c2a1104f284"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac2f2f001905150faa8f558814d82f51a1f4989e1d043a1a3b1a87ce5970c6e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70c99b064b992aed7b75e8596b25ac946c85a88e7241ec7c4256fbeb8969e71c"
    sha256 cellar: :any,                 arm64_linux:   "6a50d79f833a7509d1c620bf97e1cfb1792b005f04f062d88596857c70a2cfbe"
    sha256 cellar: :any,                 x86_64_linux:  "ae1c8a77e32ab587373e823c98d82948ef63cf643cd5831a98b593b56bb70e2d"
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
