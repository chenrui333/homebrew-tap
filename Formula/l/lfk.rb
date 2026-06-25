class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.17.tar.gz"
  sha256 "0ead17736bf2d9cea5c785985735f980004b93878c2ac2c149948a78e93a5ffd"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff978c3104ee5ca443d3d73e915c2cbbf2d710cb46b688647c4edd7bd1017fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff978c3104ee5ca443d3d73e915c2cbbf2d710cb46b688647c4edd7bd1017fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff978c3104ee5ca443d3d73e915c2cbbf2d710cb46b688647c4edd7bd1017fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb475e227761c06caf94c9bd8e894ec5053b078cde8a5f18711fb66f672fff4"
    sha256 cellar: :any,                 x86_64_linux:  "d93ebb79f7f974fceefa3a465bd2bc8d14396a465624a11af9729c2bfa346dbd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
