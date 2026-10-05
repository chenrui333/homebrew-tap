class Editly < Formula
  desc "Slick, declarative command-line video editing & API"
  homepage "https://github.com/mifi/editly"
  url "https://registry.npmjs.org/editly/-/editly-0.14.2.tgz"
  sha256 "87487bafae25c2fac59a21de935354e338d069b66b39e40a5e355ed2432820c4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "887741a148b822ba0c9311a648d6e9b6a1969804847dbf1afcaa7f514c1c9299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2953d6d235f3b5332909c472652f479062ec5197790fdd1ccc18cd12c9cd6797"
    sha256 cellar: :any,                 arm64_linux:   "84a47f87a6c034eb0c8f28d6c3d5c5123b69229fe98f2b3fffb442040b6f4c57"
    sha256 cellar: :any,                 x86_64_linux:  "2c985edc64b3352ffe0c8daf583371f2e26012c3273159ac11dd2da1362abf2c"
  end

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build # for node-gyp distutils
  depends_on "python@3.13" => :build

  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "node@22"
  depends_on "pango"
  depends_on "pixman"

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    node = Formula["node@22"]
    node_path = "#{node.opt_bin}:#{node.opt_libexec/"bin"}:$PATH"

    ENV.prepend_path "PATH", node.opt_bin
    ENV.prepend_path "PATH", node.opt_libexec/"bin"
    ENV["npm_config_nodedir"] = node.opt_prefix
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CPPFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"

    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    inreplace libexec/"lib/node_modules/editly/node_modules/gl/angle/src/common/angleutils.h",
              "#include <vector>", "#include <cstdint>\n#include <vector>"
    system "npm", "rebuild", "canvas", "gl", "--build-from-source", "--prefix", libexec/"lib/node_modules/editly"
    libexec.glob("bin/*").each do |path|
      (bin/path.basename).write_env_script path, PATH: node_path
    end
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    (testpath/"empty.json").write '{"clips":[]}'
    output = shell_output("#{bin}/editly --json empty.json 2>&1", 1)
    assert_match "Please provide at least 1 clip", output

    (testpath/"clip.txt").write "not media"
    output = shell_output("#{bin}/editly clip.txt 2>&1", 2)
    assert_match "Invalid file for clip", output
  end
end
