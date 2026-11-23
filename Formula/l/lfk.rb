class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.19.tar.gz"
  sha256 "ebaf94ae81f0946ec76b375be589c95ec4dab60b001caec4f7d6c0239488c01a"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "64702efc34c282008c0986e2a5465b215220c0d9d773381797149cb85ceb0628"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d3c2bfcdf5c7a5cbfc5481a3c99d1c53153525d12def56446542f6943de8e37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d3c2bfcdf5c7a5cbfc5481a3c99d1c53153525d12def56446542f6943de8e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d087736b336780d39282e4e881da3b43a306265e2d54561866b40c485187e677"
    sha256 cellar: :any,                 x86_64_linux:  "00cd8826c18d4d321d9149f49e2b2df261d614cef1869a0417285f7ad288e043"
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
