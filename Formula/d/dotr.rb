class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "db52c10663fd138c06e28fa4b6ce72ba225382543134f8a4886ea2f919a266c7"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9ba0f470c4ac2e2f1eea83db35c8830e30d50f101647ffdb5fde4eb9f41f67f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7fb4b31774fb6c906e06a7964e4efdcb7e3a88a0924e2193240719ed054b557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5752c9d251b28255e5ca0ab97360f4f19dad04773d214cab7f6fc60d0e4ff989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c0bdaf6939593cfc9c523074d0501544b1ebd2b8d2715e2d7fa045e28ed700d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68f875cf284bb30840911a900e238b5208a1246ddafe7d967a3d7ef5a69d9b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotr --version")

    system bin/"dotr", "init"
    assert_path_exists testpath/"config.toml"
    assert_path_exists testpath/".gitignore"
  end
end
