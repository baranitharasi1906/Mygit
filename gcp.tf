 
resource "google_compute_network" "bt-vpc"{
	name="bt-vpc"
}

resource "google_compute_subnetwork" "my-sub1"{
	name= "my-sub1"
	ip_cidr_range = "10.0.0.2/15"
	region = "us-central1"
	network = google_compute_network.bt-vpc.name
}

resource "google_compute_instance" "custom" {
	name = "hello-instance"
	zone = "us-central1-b"
	machine_type = "f1-micro"

	boot_disk{
	 initialize_params{
	 image = "ubuntu"
	}
      }
	
	network_interface{
	 network = google_compute_network.bt-vpc.name
	}
   }

resource "google_storage_bucket" "hello-bucket1"{
	name = "hello-bucket1"
	location = "US"
	
	uniform_bucket_level_access = true

        retention_policy{
         retention_period= "30"
        }

        lifecycle_rule{
         condition{
          age = 30
         }
         action{
          type= "Delete"
         }
        }

}	

resource "google_storage_bucket_object" "object"{
	name = "terraform-logo"
	source = "/h0me/downloads/object.png"
	bucket = "hello-bucket1"

	storage_class = "NEARLINE"
	
}

resource "google_sql_database" "bt-database" {
        name = "bt-database"
        instance = google_sql_database_instance.bt-sql-instance.name
}


resource "google_sql_database_instance" "bt-sql-instance" {
	name = "bt-sql-instance"
	region = "us-central1"
	database_version = "MYSQL_8_0"
	settings {
	 tier = "db-f1-micro"
	}
	deletion_protection = "true"
}

resource "google_service_account" "my-service-account"{
	account_id = "my-service-account"
}

resource "google_secret_manager_secret" "bt-secret" {
	secret_id = "secret"

	replication {
	 user_managed {
	  replicas{
	   location = "us-central1"
	   }
	  replicas {
	   location = "us-east1"
	   }
	  }
	 }
}
