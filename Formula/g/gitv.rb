class Gitv < Formula
  desc "Terminal-based viewer for GitHub issues"
  homepage "https://github.com/JayanAXHF/gitv"
  url "https://github.com/JayanAXHF/gitv/archive/refs/tags/gitv-tui-v0.4.3.tar.gz"
  sha256 "36f3eea4b2cc9cfe37278df0357172099e334092320253ddba275e22c771d971"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/gitv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb1a63489101e9b235fbba522f4faf2820bccd8d6ba0e5a617c1d4fdd6ec5c39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eba3e655c85396c5d059e3bb33fae4bc42dc16dcc7bd6eb847f7078229d0c4cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f93b48284b4d53bffcb96418d4797bbd374406e1854e3afba79aa9de5e43f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dac1bbfc312085ffa0c18fc645fd43c5a2265cedaf3a8cea23b74647c415462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8788dc25ce970444c41a4ecd14043f9c73a36254dfac3aa9d4ad2e97a4fb0bc8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    ENV["PREFIX"] = prefix
    system bin/"gitv", "--generate-man"

    generated_manpage = man1/"gitv_tui.1"
    generated_manpage.rename(man1/"gitv.1") if generated_manpage.exist?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitv --version")
    assert_match "Log directory:", shell_output("#{bin}/gitv --print-log-dir")

    ENV["PREFIX"] = testpath.to_s
    output = shell_output("#{bin}/gitv --generate-man")
    assert_match "Installed manpages:", output
    assert_path_exists testpath/"share/man/man1/gitv_tui.1"
  end
end
