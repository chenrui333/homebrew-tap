class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "047aee814b702a7ec0307f70d7ab6022be486bf5ab93b2666abd3307310584a7"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c724d6d1b229542f36d96fabeb64ad28541b390e7d423197e3deedbbb4892c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c724d6d1b229542f36d96fabeb64ad28541b390e7d423197e3deedbbb4892c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c724d6d1b229542f36d96fabeb64ad28541b390e7d423197e3deedbbb4892c6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4f496eaefe4b1ddd2517a1912d60266e14ef9e367095b8a592e6570a3ed2e15"
    sha256 cellar: :any,                 x86_64_linux:  "93e4d374f2159937d40de7410c3f1dae9353818ea783cc8d67761bd3d6af7f41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
