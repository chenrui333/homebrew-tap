class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e978c523b9bc4fcb77eed11752e671025cc613c2b6efe4476622cb229a3ef45b"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a9dd706ad5412cf0a6c379f59adc5663003ba3890ed08bb1d5fb1a59416bcdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9dd706ad5412cf0a6c379f59adc5663003ba3890ed08bb1d5fb1a59416bcdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a9dd706ad5412cf0a6c379f59adc5663003ba3890ed08bb1d5fb1a59416bcdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58dc8f8761bd36a8e9d32b18ebc961cb941a46993bd891957d9145f0356c7658"
    sha256 cellar: :any,                 x86_64_linux:  "8cf0f3b29e370407e5b6e333177af86c16dcec9ce797b2891b1c3af121da926a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
