# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.5.tar.gz"
  sha256 "4474747e8e09a5d44ef1af9150cfed5a0e93a61075f04125b9d84036f92f6cb9"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60711f585560d0ee1ca65c3a48f56b68823429f6b5c67b262b08dcb28664fe3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60711f585560d0ee1ca65c3a48f56b68823429f6b5c67b262b08dcb28664fe3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60711f585560d0ee1ca65c3a48f56b68823429f6b5c67b262b08dcb28664fe3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ade023314fc64a548107e3d0cde41d4d78376c0494cb4bee0582f514286df42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7e07ae7412d296267af1b47b062da987c18a5b8f8b670140ae93b52091da4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user} -X main.Date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cohctl"

    generate_completions_from_executable(bin/"cohctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cohctl version")

    output = shell_output("#{bin}/cohctl describe cluster test 2>&1", 1)
    assert_match "unable to find cluster with connection name test", output
  end
end
