class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "047aee814b702a7ec0307f70d7ab6022be486bf5ab93b2666abd3307310584a7"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efcd8380b8409276e3c88784b477b899b8d1f94a215ec42c847f78578d21bff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efcd8380b8409276e3c88784b477b899b8d1f94a215ec42c847f78578d21bff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efcd8380b8409276e3c88784b477b899b8d1f94a215ec42c847f78578d21bff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a6690b7d7f74120de226d091b5f76d760804a786e1d418ecc0f908dd2d91e8"
    sha256 cellar: :any,                 x86_64_linux:  "d56eb4a68be3db57b1915755b7501ad591c5751e70b0156756928baa2ec5ca5e"
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
