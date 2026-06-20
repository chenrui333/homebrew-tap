class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e978c523b9bc4fcb77eed11752e671025cc613c2b6efe4476622cb229a3ef45b"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be0f7a7852874ae1abd45d530f9c0548041a79aaafb766efca637273af3be98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be0f7a7852874ae1abd45d530f9c0548041a79aaafb766efca637273af3be98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2be0f7a7852874ae1abd45d530f9c0548041a79aaafb766efca637273af3be98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4ea8e2676a0f0a33485b23246d7a14d8200f989cf1e223cb35e48498bc2ae6f"
    sha256 cellar: :any,                 x86_64_linux:  "c805ee713452f5f76275ebdb2a731fd4763724383e24fe052db68afd4dfbea36"
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
