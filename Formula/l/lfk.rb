class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.20.tar.gz"
  sha256 "22e8884a9a12c64b6ef6621e7da56f6abfbdd674c7244eb8520c3a1d65b68457"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "2ba3822d9b91a1982e36df6d138786dbe51e731f452f6aae0676b7a27bd84e56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c19970bf5e8e9f564c4286bd9c8c3faba269d568369bd03999f165af3d8deed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c19970bf5e8e9f564c4286bd9c8c3faba269d568369bd03999f165af3d8deed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb19120da00571acc8c24e9843074a869eabb086687b0ee715e60fb777c725f0"
    sha256 cellar: :any,                 x86_64_linux:  "6f105f44c6ea525e070385b9897b187ffa8ebf71b484b9b3dff1c0738fe88e96"
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
