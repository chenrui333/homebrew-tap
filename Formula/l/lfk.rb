class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.17.tar.gz"
  sha256 "23f92bbb405951a6cab8f6ec1d5920eaa9e5c5e731f6f04a955abdd3cb210f5d"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddcdf50b1d01d1cf45385cea6e2e3324cf072f4f317b01c24de2685ee323d90c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddcdf50b1d01d1cf45385cea6e2e3324cf072f4f317b01c24de2685ee323d90c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a185d64aa0aca95db674532a6ac91aafd1807d86344584b127a389a3c499f8a"
    sha256 cellar: :any,                 x86_64_linux:  "e3b595f865d4c6c36417727ce9fc199f85226d7100aee602cc16a2dec331be70"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
