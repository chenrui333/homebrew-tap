class Vento < Formula
  desc "Lightweight CLI Tool for File Transfer"
  homepage "https://github.com/kyotalab/vento"
  url "https://github.com/kyotalab/vento/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "493ca4d72c756ecc0773cfc2fca1731b03d4a3781107b2e32c2586c5c3600488"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad446a9f9ef6b60cf3fa56a07677cc4049935e2bbe61074c69b9f98071af24c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e74ed8863391431c188bb7abd8e5bc4c5fb95799a8e398f7e506b66c97bd646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d89555a9a1718defb7acff310e5896328899b123e1d07db496578b486449315"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbafc20b71ca775581cf3c6643374705c104a6627ee3d6aa0059c29c2e2f5cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda793c8c064c06bb930f93abaead560afc11d7788acd953e05ce3e9727f0f85"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vento --version")

    output = shell_output("#{bin}/vento admin 2>&1", 1)
    assert_match "Error: Failed to load default application configuration", output
  end
end
