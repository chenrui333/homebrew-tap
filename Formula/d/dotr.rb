class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "49b841077fc81b1f0bf1a3d24cb3cbe215df575afd54da7ed698a7eb1aab773e"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "062b52745cfd02c4ca5b1fe736be4b2f37c57e261286100c4e165424b28d2831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c71aa8af08e7a8b6b579e4edd689af0627d7b588db9bda8db207907e5375fad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98589eefbb0b2d22e9fc6323bf9c3a39c05d7ae78d8d3d58cceeb6972a73e99"
    sha256 cellar: :any,                 arm64_linux:   "06c882f1b6f4f6a8c712edcdf8e40c743ccd45fe06bffe42c755a8261c67e721"
    sha256 cellar: :any,                 x86_64_linux:  "7171b250ff262291bf4f20816994eeffb281ed870502b71919080d4654727c81"
  end

  depends_on "rust" => :build

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
