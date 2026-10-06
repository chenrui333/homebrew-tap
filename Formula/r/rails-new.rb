class RailsNew < Formula
  desc "Create Rails projects with Ruby installed"
  homepage "https://github.com/rails/rails-new"
  url "https://github.com/rails/rails-new/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9a309ea0d3f7b7c10327aba30e919bab30efc3bdffc2fcedaa54ce23d9e4ae42"
  license "MIT"
  head "https://github.com/rails/rails-new.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06b862857ac7eef7f62a66617c704e50c121e67a1a264daf93a1e1dae3c8f849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d8e07699ba98bd13dae6a4e4e719ad03294874deaad82ce6f6a014692aff84"
    sha256 cellar: :any,                 arm64_linux:   "9d8bb988c0c7e13836a7d9ae28e317d858d289b2cb9720af23f65c8b32dfe452"
    sha256 cellar: :any,                 x86_64_linux:  "09df003e255d5553b468c259204332b1246bdaf28c7453edcad6a6b05acac528"
  end

  depends_on "rust" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/rails-new --version")

    output = shell_output("#{bin}/rails-new testapp 2>&1", 101)
    # Docker 29+ reports "failed to connect to the docker API" instead
    assert_match(/Cannot connect to the Docker daemon|failed to connect to the docker API/, output)
  end
end
