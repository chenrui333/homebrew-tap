class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "779648dc35b05b061799b82fa23dd61128d7ffc1bfd6701fa327d2d7ac9e5dd8"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08845b1a3575e6e95e19608b18c544f170c9ccb03e8569d03097f96d807cda1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60b91e82920c948173da858da763968f6d2a9b8c34860fa9e1de9257cab5c273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1275c80921047188bdbe48433af8b7078b6f1cd11b4a828d336eed81dc348474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f972755fa31abfada3f2fc7445609984bd383d637beac13bdb392daff4531824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa13e2c83cbcab57c2a20ac3326b9672be6469309e1bec6f8d75e1bc0f5fed98"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
