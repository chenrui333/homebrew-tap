class Editly < Formula
  desc "Slick, declarative command-line video editing & API"
  homepage "https://github.com/mifi/editly"
  url "https://registry.npmjs.org/editly/-/editly-0.14.2.tgz"
  sha256 "87487bafae25c2fac59a21de935354e338d069b66b39e40a5e355ed2432820c4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "2bd3efb8e321768285440ea2fd4dcb2e8c9c50342d5a74dae7d17bbf6beec628"
    sha256               arm64_sequoia: "0bda7a4ad79134a945c975b18919cdb38e987c473ccf4119473e147b3e02f5d9"
    sha256               arm64_sonoma:  "4423ca2c61ec7fe15d5ba4e819b4df6a5001cae6599ee6735bcad53d8bb0b243"
    sha256 cellar: :any, arm64_linux:   "f0416d9e2819a4d8f7e76cf3c5ec4785a785f002309c3163a110bf2ef9436166"
    sha256 cellar: :any, x86_64_linux:  "442f2e16d818149eeb98e2e37ad462ae4adee36ea7ac7ad886d58c80d67e340c"
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

  def install
    node = Formula["node@22"]
    node_path = "#{node.opt_bin}:#{node.opt_libexec/"bin"}:$PATH"

    ENV.prepend_path "PATH", node.opt_bin
    ENV.prepend_path "PATH", node.opt_libexec/"bin"
    ENV["npm_config_nodedir"] = node.opt_prefix
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CPPFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"

    system "npm", "install", *std_npm_args
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
