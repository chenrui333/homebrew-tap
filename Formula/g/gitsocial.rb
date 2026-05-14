class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "f271e8782b95e0050a57ceb0222f30e66550a49cf9b0d7162dd7d4eb7875ded2"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df126c9daf7a9ea2f911f0ef1edc8e9835de4004a9c43e4200b1566dee511947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df126c9daf7a9ea2f911f0ef1edc8e9835de4004a9c43e4200b1566dee511947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df126c9daf7a9ea2f911f0ef1edc8e9835de4004a9c43e4200b1566dee511947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8604364d71cafed07098f2a7a50cfb8b85cafdd8081ca5434526748e85db88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31bd4a89d32686bd2904a052e35c6a4795571aa93d483c40d91710b21fbc9ede"
  end

  depends_on "go" => :build

  def install
    Dir.chdir("library") do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli"
    end

    generate_completions_from_executable(bin/"gitsocial", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
