class Dawn < Formula
  desc "Distraction-free terminal writing environment with live markdown rendering"
  homepage "https://github.com/andrewmd5/dawn"
  url "https://github.com/andrewmd5/dawn/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "7b01b89a87cdfe34e17401ec8497176abd1c65387fd7f9cb286d3c4b28b619cc"
  license "MIT"
  head "https://github.com/andrewmd5/dawn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6039749249f63c460808c38d248a8bc72e2455a13e27137c760e546bfee77ffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e188e1162d85c4e41d32732adc5274f6e9dc7f83d722827db428aeea2e595a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a210d7778dafba5671d2471f067d30c2f41040278abd0f904879650838d8c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa3faacb6ad8f00c6890ef5258529a50301dbd60a018e1b4e187211beae05572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10fd5b53586c1bf7ce5fdc1e060599a447b7522ef1be0f9743d6d1f5f2d781a"
  end

  depends_on "cmake" => :build
  depends_on "curl"

  resource "cyaml" do
    url "https://github.com/andrewmd5/cyaml/archive/0672e81b809bc3dfd1d4f57ba0fcfbb20c60ae70.tar.gz"
    sha256 "0c08eed9756056dea0ef603685c6a7019a370a8675186f1a4db9a519e61f6926"
  end

  resource "nanosvg" do
    url "https://github.com/memononen/nanosvg/archive/5cefd9847949af6df13f65027fd43af5a7513633.tar.gz"
    sha256 "01f0892f15c12e364063c07ef643f566372593f60e7010b33707a3804bf74aa1"
  end

  resource "pcre2" do
    url "https://github.com/PCRE2Project/pcre2/archive/a1508f74f13c9227714cf16c342443691f854144.tar.gz"
    sha256 "5d51b5b8a71095c1e9605073a2b8ec374ee1b4723f4d54f1086867e8af9fc53d"
  end

  resource "utf8proc" do
    url "https://github.com/JuliaStrings/utf8proc/archive/90daf9f396cfec91668758eb9cc54bd5248a6b89.tar.gz"
    sha256 "cf6c76d588eb607b77dd6797cf65f8e88873e9f98c40085fc46070fe5626c70c"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init", "--recursive"
    else
      # Upstream release tarballs omit git submodules needed for source builds.
      mkdir_p buildpath/"third-party"
      resource("cyaml").stage buildpath/"third-party/cyaml"
      resource("nanosvg").stage buildpath/"third-party/nanosvg"
      resource("pcre2").stage buildpath/"third-party/pcre2"
      resource("utf8proc").stage buildpath/"third-party/utf8proc"
    end

    # The vendored PCRE2 checkout expects a nested sljit checkout for JIT.
    inreplace "CMakeLists.txt",
              'set(PCRE2_SUPPORT_JIT ON CACHE BOOL "" FORCE)',
              'set(PCRE2_SUPPORT_JIT OFF CACHE BOOL "" FORCE)'

    mkdir "build" do
      system "cmake", "..", "-DDAWN_VERSION=#{version}", *std_cmake_args
      system "cmake", "--build", ".", "--target", "dawn"
      bin.install "dawn"
    end
  end

  test do
    (testpath/"sample.md").write <<~MARKDOWN
      # Hello from Homebrew

      This is a test.
    MARKDOWN

    assert_match version.to_s, shell_output("#{bin}/dawn -v")

    rendered = shell_output("#{bin}/dawn -P #{testpath}/sample.md")
    rendered = rendered.gsub(/\e\][^\a\e]*(?:\a|\e\\)/, "")
    rendered = rendered.gsub(%r{\e\[[0-9;?]*[ -/]*[@-~]}, "")
    rendered = rendered.gsub(/\e_[^\e]*(?:\e\\)/, "")
    rendered = rendered.gsub(/\e[@-_]/, "")

    assert_match "# Hello from Homebrew", rendered
    assert_match "This is a test.", rendered
  end
end
