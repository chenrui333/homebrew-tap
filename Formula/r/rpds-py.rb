class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ca/0e/4c797078d00dbf1f63af96e4b3beffb67f71230f58442272b4b1962a61c8/rpds_py-0.23.0.tar.gz"
  sha256 "ffac3b13182dc1bf648cde2982148dc9caf60f3eedec7ae639e05636389ebf5d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "0f86d31cedc8345b9e8984125d639bdc383bb2c07b603543cb29002aeb02a3e4"
    sha256 cellar: :any,                 arm64_sonoma:  "1e19956398889b02e613ea5452c14e2f5a1509d6f800bfd7f5155212ab7d26d2"
    sha256 cellar: :any,                 ventura:       "ec2529c8696e722a332ccfd4ef0434d5dfae3509ce66e38ab6925c0c472587e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716ac3ea4c4469cf5c6790a256170a00961e8cbadea38d80e7b551ccdccf3632"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "rust" => :buil

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/e0/8f/6978427ce3f72b189012e1731d1d2d27b3151caa741666c905320e0a3662/maturin-1.8.2.tar.gz"
    sha256 "e31abc70f6f93285d6e63d2f4459c079c94c259dd757370482d2d4ceb9ec1fa0"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/d3/6b/99a1588d826ceb108694ba00f78bc6afda10ed5d72d550ae8f256af1f7b4/setuptools_rust-1.10.2.tar.gz"
    sha256 "5d73e7eee5f87a6417285b617c97088a7c20d1a70fcea60e3bdc94ff567c29dc"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV.append_path "PATH", buildpath/"bin"
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      deps = %w[setuptools setuptools-rust semantic-version maturin]
      deps.each do |r|
        resource(r).stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from rpds import HashTrieMap, HashTrieSet, List

      m = HashTrieMap({"foo": "bar", "baz": "quux"})
      assert m.insert("spam", 37) == HashTrieMap({"foo": "bar", "baz": "quux", "spam": 37})
      assert m.remove("foo") == HashTrieMap({"baz": "quux"})

      s = HashTrieSet({"foo", "bar", "baz", "quux"})
      assert s.insert("spam") == HashTrieSet({"foo", "bar", "baz", "quux", "spam"})
      assert s.remove("foo") == HashTrieSet({"bar", "baz", "quux"})

      L = List([1, 3, 5])
      assert L.push_front(-1) == List([-1, 1, 3, 5])
      assert L.rest == List([3, 5])
    EOS

    pythons.each do |python3|
      system python3, "test.py"
    end
  end
end
