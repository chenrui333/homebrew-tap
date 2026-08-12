cask "cc-hdrm" do
  version "1.5.0"
  sha256 "a09014a9f735f54f224cfd6100b89c19c47a971dd38ab8d32ecd84acc75319c5"

  url "https://github.com/rajish/cc-hdrm/releases/download/v#{version}/cc-hdrm-#{version}.dmg"
  name "cc-hdrm"
  desc "Menu bar utility showing Claude subscription session headroom"
  homepage "https://github.com/rajish/cc-hdrm"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: :sonoma

  app "cc-hdrm.app"

  zap trash: [
    "~/Library/Application Support/cc-hdrm",
    "~/Library/Caches/com.cc-hdrm.app",
    "~/Library/HTTPStorages/com.cc-hdrm.app",
  ]
end
