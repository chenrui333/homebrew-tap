class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a1ac76b080932acd374905e9ed8ffc47a6c0e481a0a050ed8c2b07d7576c6b03"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "719e6e0d4e677449a987ea77eae10acc3ad11cfab5537a4a9f8a13c41b988c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4090c70ab85963ff4e21c27fc040e4aefbe79967d47a96e2617226ec94a093db"
    sha256 cellar: :any,                 arm64_linux:   "0a4c1acccc5f4c9f81cef967a3b66277e5eddaa92b0a3019b4a5ad370962f748"
    sha256 cellar: :any,                 x86_64_linux:  "cc6444650d5654ccc06981fd33396029d4490fff754dc865933b16609cda87d5"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")

    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aube --version")
    assert_path_exists bin/"aubr"
    assert_path_exists bin/"aubx"

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
