class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide/archive/refs/tags/0.23.0.tar.gz"
  sha256 "901f1de739eb026e24f5f929665d1d9b004c2030b6e2d8a4ba989902c5782351"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "88af645f738879706a823a0efce720cb1b12297e5025988479fd7bf447fd9716"
    sha256                               arm64_sequoia: "38cc02e07e93f65bfc7cbebb4a0ba375d7c3990d01e42609bc7f96bde1d7cd41"
    sha256                               arm64_sonoma:  "ee3b50f951f61605a0eae8fca7b93daaf53482d229fec875b755e02e2fb24eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9fae37721014eb7fa000388d95dc0e1aa530ef07226b0e3360f1bd92d234fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d08a7e7f98aeeaae1c7035691a2696a8119d36635be47fac8847a717831d9529"
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
    assert_match version.to_s, shell_output("#{bin}/termide --version")
  end
end
