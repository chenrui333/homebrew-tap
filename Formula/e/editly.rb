class Editly < Formula
  desc "Slick, declarative command-line video editing & API"
  homepage "https://github.com/mifi/editly"
  url "https://registry.npmjs.org/editly/-/editly-0.14.2.tgz"
  sha256 "87487bafae25c2fac59a21de935354e338d069b66b39e40a5e355ed2432820c4"
  license "MIT"

  depends_on "pkgconf" => :build
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

  def install
    node = Formula["node@22"]
    node_path = "#{node.opt_bin}:#{node.opt_libexec/"bin"}:$PATH"

    ENV.prepend_path "PATH", node.opt_bin
    ENV.prepend_path "PATH", node.opt_libexec/"bin"
    ENV["npm_config_nodedir"] = node.opt_prefix
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CPPFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"

    system "npm", "install", *std_npm_args
    system "npm", "rebuild", "canvas", "gl", "--build-from-source", "--prefix", libexec/"lib/node_modules/editly"
    libexec.glob("bin/*").each do |path|
      (bin/path.basename).write_env_script path, PATH: node_path
    end
  end

  test do
    assert_match "Simple, sexy, declarative video editing", shell_output("#{bin}/editly --help")

    (testpath/"clip.txt").write "not media"
    output = shell_output("#{bin}/editly clip.txt 2>&1", 2)
    assert_match "Invalid file for clip", output
  end
end
