resource "google_project_iam_custom_role" "pd_csi_custom_role" {
  role_id     = "pd_csi_custom_role"
  title       = "PD CSI Driver Custom Role"
  description = "Custom role for managing Persistent Disks and Snapshots"
  permissions = [
    "compute.disks.create",
    "compute.disks.delete",
    "compute.disks.get",
    "compute.disks.setLabels",
    "compute.snapshots.create",
    "compute.snapshots.delete",
    "compute.instances.attachDisk",
    "compute.instances.detachDisk"
  ]
  project = var.project_id
}

resource "google_service_account" "pd_csi_service_account" {
  account_id   = "pd-csi-service-account"
  display_name = "Service account for Persistent Disk CSI driver"
}

resource "google_project_iam_member" "pd_csi_iam_binding" {
  role    = google_project_iam_custom_role.pd_csi_custom_role.name
  member  = "serviceAccount:${google_service_account.pd_csi_service_account.email}"
  project = var.project_id
}
